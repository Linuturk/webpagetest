packages:
  pkg.installed:
    - pkgs: {{ pillar['webpagetest']['packages'] }}

ffmpeg:
  pkgrepo.managed:
    - ppa: jon-severinsson/ffmpeg
  pkg.installed:
    - name: ffmpeg
    - refresh: True

httpservices:
  pkg.installed:
    - pkgs:
      - {{ pillar['webpagetest']['http'] }}
      - {{ pillar['webpagetest']['php'] }}

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

include:
  - webpagetest.{{ pillar['webpagetest']['http'] }}
