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

webpagetest-apache-modules:
  apache_module.enable:
    - name:
      - expires
      - headers
      - rewrite

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

# Configure Virtual Host
# Pull Webpagetest tarball
# Extract to Docroot
