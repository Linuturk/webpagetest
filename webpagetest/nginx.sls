{% set sitename = salt['pillar.get']('webpagetest:sitename') %}

remove-apache2:
  pkg.removed:
    - name: apache2

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: httpservices

/etc/nginx/sites-enabled/{{ sitename }}.conf:
  file.symlink:
    - target: ../sites-available/{{ sitename }}.conf
    - require:
      - pkg: httpservices

/etc/nginx/sites-available/{{ sitename }}.conf:
  file.managed:
    - source: salt://webpagetest/files/nginx.conf
    - template: jinja
    - require:
      - pkg: httpservices
  service.running:
    - name: nginx
    - watch:
        - file: /etc/nginx/sites-available/{{ sitename }}.conf
        - file: /etc/nginx/include/{{ sitename }}.include.conf
    - require:
      - pkg: httpservices

/etc/nginx/include/{{ sitename }}.include.conf:
  file.managed:
    - source: salt://webpagetest/files/nginx.include.conf
    - template: jinja
    - makedirs: True
    - require:
      - pkg: httpservices

/etc/php5/fpm/php.ini:
  file.managed:
    - source: salt://webpagetest/files/php.ini
    - template: jinja
    - require:
      - pkg: httpservices
  service.running:
    - name: php5-fpm
    - watch:
      - file: /etc/php5/fpm/php.ini
    - require:
      - pkg: httpservices
