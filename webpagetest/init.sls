{% set webpagetest = salt['pillar.get']('webpagetest') %}

packages:
  pkg.installed:
    - pkgs: {{ webpagetest.packages }}

ffmpeg:
  pkgrepo.managed:
    - ppa: jon-severinsson/ffmpeg
  pkg.installed:
    - name: ffmpeg
    - refresh: True

httpservices:
  pkg.installed:
    - pkgs:
      - {{ webpagetest.http }}
      - {{ webpagetest.php }}

extract-webpagetest:
  archive.extracted:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}
    - source: {{ webpagetest.zipurl }}
    - source_hash: {{ webpagetest.zipsha }}
    - archive_format: zip
    - if_missing: /var/www/vhosts/{{ webpagetest.sitename }}/www

correct-document-root-permissions:
  file.directory:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}/www
    - user: www-data
    - group: www-data
    - file_mode: 644
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
    - require_in:
      - mount: mount-tmpfs

install-wpt-cron-updater:
  file.managed:
    - name: /etc/cron.daily/wptupdate
    - source: salt://webpagetest/files/wptupdate.cron
    - template: jinja
    - user: root
    - group: root
    - mode: 755

include:
  - webpagetest.{{ webpagetest.http }}

mount-tmpfs:
  mount.mounted:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}/www/tmp
    - device: tmpfs
    - fstype: tmpfs
    - mkmnt: True
    - opts:
      - size=256m

settings-config:
  file.managed:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}/www/settings/settings.ini:
    - source: salt://webpagetest/files/settings.ini
    - template: jinja

locations-config:
  file.managed:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}/www/settings/locations.ini:
    - source: salt://webpagetest/files/locations.ini
    - template: jinja

feeds-config:
  file.managed:
    - name: /var/www/vhosts/{{ webpagetest.sitename }}/www/settings/feeds.inc:
    - source: salt://webpagetest/files/feeds.inc
    - template: jinja
