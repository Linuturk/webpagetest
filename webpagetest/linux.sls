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

# Configure Virtual Host
# Pull Webpagetest tarball
# Extract to Docroot
