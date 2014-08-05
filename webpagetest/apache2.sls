/etc/apache2/mods-enabled/expires.load:
  file.symlink:
    - target: ../mods-available/expires.load

/etc/apache2/mods-enabled/headers.load:
  file.symlink:
    - target: ../mods-available/headers.load

/etc/apache2/mods-enabled/rewrite.load:
  file.symlink:
    - target: ../mods-available/rewrite.load

/etc/apache2/sites-enabled/000-default.conf:
  file.absent

/etc/apache2/sites-enabled/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.symlink:
    - target: ../sites-available/{{ pillar['webpagetest']['sitename'] }}.conf

/etc/apache2/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf:
  file.managed:
    - source: salt://webpagetest/files/apache.conf
    - template: jinja
  service.running:
    - name: apache2
      watch:
        - file: /etc/apache2/sites-available/{{ pillar['webpagetest']['sitename'] }}.conf
        - file: /etc/php5/apache2/php.ini

/var/www/vhosts/{{ pillar['webpagetest']['sitename'] }}:
  archive.extracted:
    - source: pillar['webpagetest']['zipurl']
    - source_hash: pillar['webpagetest']['zipsha']
    - archive_format: zip
    - if_missing: /var/www/vhosts/{{ pillar['webpagetest']['sitename'] }}/www

/var/www/vhosts/{{ pillar['webpagetest']['sitename'] }}/www:
  file.directory:
    - user: www-data
    - group: www-data
    - file_mode: 644
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode

/etc/php5/apache2/php.ini:
  file.managed:
    - source: salt://webpagetest/files/apache.php.ini
    - template: jinja
