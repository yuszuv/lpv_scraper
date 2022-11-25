Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    csv_file = target["settings"].csv_file
    config = ROM::Configuration.new(:csv, csv_file)

    register "config", config
    register "db", config.gateways[:default].connection
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
