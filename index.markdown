---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---
<ul>
  {% for post in site.posts %}
    <li>
      <a href="/github-pages-with-jekyll{{ _posts/post.url }}">{{ _posts/post.title }}</a>
    </li>
  {% endfor %}
</ul>
