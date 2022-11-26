module LPVScraper
  class ArticlesRepo
    include Deps["persistence.rom"]

    def create(attrs)
      rom.relations[:articles]
        .command(:create, result: :one)
        .call(**attrs)
    end
  end
end
