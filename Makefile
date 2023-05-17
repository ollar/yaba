extract_locales:
	pybabel extract --no-wrap --omit-header --mapping-file light_theme/babel.cfg --output-file light_theme/messages.pot light_theme


init_locale:
	pybabel init --input-file light_theme/messages.pot --output-dir light_theme/locales -l ru


update_locale:
	pybabel update --omit-header --input-file light_theme/messages.pot --output-dir light_theme/locales -l ru


compile_locale:
	pybabel compile --statistics --directory light_theme/locales -l ru
