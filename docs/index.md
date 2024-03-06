{% for nav_item in navigation %}
{% if nav_item.is_section and nav_item.title == 'Жизнь' %}
{% for page in nav_item.children %}
1. ### [{{page.title}}]({{page.url}})
{% endfor %}
{% endif %}
{% endfor %}
