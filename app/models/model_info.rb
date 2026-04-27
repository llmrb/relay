# frozen_string_literal: true

module Relay::Models
  class ModelInfo < Sequel::Model
    include Relay::Model
    plugin :validation_class_methods

    set_dataset :model_infos

    validates_presence_of :provider, :model_id, :name, :synced_at

    ##
    # Replaces all stored model metadata for a provider in one transaction.
    #
    # Existing rows for the provider are deleted before the new rows are
    # inserted. An empty `models` array clears the provider's stored model
    # metadata.
    #
    # @param [String] provider
    # @param [Array<Hash>] models
    # @return [void]
    def self.replace!(provider, models)
      now = Time.now.utc
      db.transaction do
        where(provider:).delete
        multi_insert(models.map {
          {
            provider:,
            model_id: _1[:model_id],
            name: _1[:name],
            chat: _1[:chat],
            data: JSON.generate(_1[:data] || {}),
            synced_at: now,
            created_at: now,
            updated_at: now
          }
        }) unless models.empty?
      end
    end

    def data
      value = self[:data]
      return value if Hash === value
      return JSON.parse(value) if String === value && !value.empty?
      {}
    rescue JSON::ParserError
      {}
    end
  end
end
