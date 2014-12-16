module RevisionData
  def self.load(revision)
    Loader.new(revision).to_hash
  end

  class Loader
    attr_reader :revision

    delegate :id, :created_at, :data, to: :revision
    delegate :author, to: :revision
    delegate :name, to: :author, prefix: true, allow_nil: true

    def initialize(revision)
      @revision = revision
    end

    def text
      data[type.to_sym]
    end

    def type
      return 'event' if data[:event].present?

      if data[:note].present?
        'note'
      else
        'blocks_attributes'
      end
    end

    def to_hash
      {
        id:         id,
        author:     author_name,
        type:       type,
        text:       text,
        created_at: created_at
      }
    end
  end
end
