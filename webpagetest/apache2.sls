remove-nginx:
  pkg.removed:
    - name: nginx

/etc/apache2/mods-enabled/expires.load:
  file.symlink:
    - target: ../mods-available/expires.load
    - require:
      - pkg: httpservices

/etc/apache2/mods-enabled/headers.load:
  file.symlink:
    - target: ../mods-available/headers.load
    - require:
      - pkg: httpservices

/etc/apache2/mods-enabled/rewrite.load:
  file.symlink:
    - target: ../mods-available/rewrite.load
    - require:
      - pkg: httpservices

/etc/apache2/sites-enabled/000-default.conf:
  file.absent:
    - require:
      - pkg: httpservices

/etc/apache2/sites-enabled/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.symlink:
    - target: ../sites-available/{{ pillar['webpagetest']['sitename'] }}.conf
    - require:
      - pkg: httpservices

/etc/apache2/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.managed:
    - source: salt://webpagetest/files/apache.conf
    - template: jinja
    - require:
      - pkg: httpservices
  service.running:
    - name: apache2
    - watch:
        - file: /etc/apache2/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf
        - file: /etc/php5/apache2/php.ini
    - require:
      - pkg: httpservices

/etc/php5/apache2/php.ini:
  file.managed:
    - source: salt://webpagetest/files/php.ini
    - template: jinja
    - require:
      - pkg: httpservices
