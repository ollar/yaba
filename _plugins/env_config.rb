Jekyll::Hooks.register :site, :after_init do |site|
  site.config['site_name'] = ENV.fetch('SITE_NAME', 'yaba')
end
