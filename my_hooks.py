import os

def on_post_build(config):
  os.system('optimize-images ./site -mw 1024 -mh 1024')
