webpagetest-packages:
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

include:
  - {{ pillar['webpagetest']['http'] }}
