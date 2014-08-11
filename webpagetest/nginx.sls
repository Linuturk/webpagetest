remove-apache2:
  pkg.removed:
    - name: apache2

/etc/nginx/sites-enabled/default:
  file.absent

/etc/nginx/sites-enabled/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.symlink:
    - target: ../sites-available/{{ pillar['webpagetest']['sitename'] }}.conf

/etc/nginx/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.managed:
    - source: salt://webpagetest/files/nginx.conf
    - template: jinja
  service.running:
    - name: nginx
    - watch:
        - file: /etc/nginx/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf
        - file: /etc/nginx/include/{{ pillar['webpagetest']['sitename'] }}.include.conf
    - require:
      - pkg: nginx

/etc/nginx/include/{{ pillar['webpagetest']['sitename'] }}.include.conf:
  file.managed:
    - source: salt://webpagetest/files/nginx.include.conf
    - template: jinja
    - makedirs: True

/etc/php5/fpm/php.ini:
  file.managed:
    - source: salt://webpagetest/files/php.ini
    - template: jinja
  service.running:
    - name: php5-fpm
    - watch:
      - file: /etc/php5/fpm/php.ini
