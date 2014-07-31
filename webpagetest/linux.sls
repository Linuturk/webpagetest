webpagetest-packages:
  pkg.installed:
    - pkgs:
      - apache2
      - php5
      - imagemagick
      - libimage-exiftool-perl
      - libjpeg-turbo-progs
      - python-software-properties
      - php5-curl
      - php5-gd
      - php5-sqlite
      - php5-apcu

ffmpeg:
  pkgrepo.managed:
    - ppa: jon-severinsson/ffmpeg
  pkg.installed:
    - name: ffmpeg
    - refresh: True

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

/etc/apache2/sites-enabled/webpagetest.rax.io.conf:
  file.symlink:
    - target: ../sites-available/webpagetest.rax.io.conf

/etc/apache2/sites-available/webpagetest.rax.io.conf:
  file.managed:
    - source: salt://webpagetest/files/webpagetest.rax.io.conf
  service.running:
    - name: apache2
      watch:
        - file: /etc/apache2/sites-enabled/webpagetest.rax.io.conf

/var/www/vhosts/webpagetest.rax.io:
  archive.extracted:
    - source: https://github.com/WPO-Foundation/webpagetest/releases/download/WebPagetest-2.15/webpagetest_2.15.zip
    - source_hash: sha256=19ee9df78205f99153c6fa80b6e6e98394cc680c4a9e13b31bf4c7a9e374bad8
    - archive_format: zip
    - if_missing: /var/www/vhosts/webpagetest.rax.io/www

/var/www/vhosts/webpagetest.rax.io/www:
  file.directory:
    - user: www-data
    - group: www-data
    - file_mode: 644
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
