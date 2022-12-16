Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    csv_file = target["settings"].csv_file
    config = ROM::Configuration.new(default: [:csv, csv_file], legacy: [:sql, target["settings"].database_url])

    register "config", config
    register "db", config.gateways[:legacy].connection
  end

  start do
    config = target["persistence.config"]

    config.auto_registration(
      target.root.join("lib/lpv_scraper/persistence"),
      namespace: "LPVScraper::Persistence"
    )

    register "rom", ROM.container(config)
  end
end
