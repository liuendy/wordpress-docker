#!/bin/bash

cd /usr/share/nginx/www

# based on code from: https://github.com/docker-library/wordpress/

# TODO handle WordPress upgrades magically in the same way, but only if wp-includes/version.php's $wp_version is less than /usr/src/wordpress/wp-includes/version.php's $wp_version

# version 4.4.1 decided to switch to windows line endings, that breaks our seds and awks
# https://github.com/docker-library/wordpress/issues/116
# https://github.com/WordPress/WordPress/commit/1acedc542fba2482bab88ec70d4bea4b997a92e4
sed -ri 's/\r\n|\r/\n/g' wp-config*

if [ ! -e wp-config.php ]; then
	cp wp-config-sample.php wp-config.php
	chown www-data:www-data wp-config.php
fi

# see http://stackoverflow.com/a/2705678/433558
sed_escape_lhs() {
	echo "$@" | sed 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
	echo "$@" | sed 's/[\/&]/\\&/g'
}
php_escape() {
	php -r 'var_export(('$2') $argv[1]);' "$1"
}
set_config() {
	key="$1"
	value="$2"
	var_type="${3:-string}"
	start="(['\"])$(sed_escape_lhs "$key")\2\s*,"
	end="\);"
	if [ "${key:0:1}" = '$' ]; then
		start="^(\s*)$(sed_escape_lhs "$key")\s*="
		end=";"
	fi
	sed -ri "s/($start\s*).*($end)$/\1$(sed_escape_rhs "$(php_escape "$value" "$var_type")")\3/" wp-config.php
}

set_config 'DB_HOST' "$WORDPRESS_DB_HOST"
set_config 'DB_USER' "$WORDPRESS_DB_USER"
set_config 'DB_PASSWORD' "$WORDPRESS_DB_PASSWORD"
set_config 'DB_NAME' "$WORDPRESS_DB_NAME"

# allow any of these "Authentication Unique Keys and Salts." to be specified via
# environment variables with a "WORDPRESS_" prefix (ie, "WORDPRESS_AUTH_KEY")
UNIQUES=(
	AUTH_KEY
	SECURE_AUTH_KEY
	LOGGED_IN_KEY
	NONCE_KEY
	AUTH_SALT
	SECURE_AUTH_SALT
	LOGGED_IN_SALT
	NONCE_SALT
)
for unique in "${UNIQUES[@]}"; do
	eval unique_value=\$WORDPRESS_$unique
	if [ "$unique_value" ]; then
		set_config "$unique" "$unique_value"
	else
		# if not specified, let's generate a random value
		current_set="$(sed -rn "s/define\((([\'\"])$unique\2\s*,\s*)(['\"])(.*)\3\);/\4/p" wp-config.php)"
		if [ "$current_set" = 'put your unique phrase here' ]; then
			set_config "$unique" "$(head -c1M /dev/urandom | sha1sum | cut -d' ' -f1)"
		fi
	fi
done

if [ "$WORDPRESS_TABLE_PREFIX" ]; then
	set_config '$table_prefix' "$WORDPRESS_TABLE_PREFIX"
fi

if [ "$WORDPRESS_DEBUG" ]; then
	set_config 'WP_DEBUG' 1 boolean
fi

