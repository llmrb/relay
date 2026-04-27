# frozen_string_literal: true

module Relay
  module ModelInfo
    class Sync
      PROVIDERS = {
        "anthropic" => -> { LLM.anthropic(key: ENV["ANTHROPIC_SECRET"]) },
        "deepseek" => -> { LLM.deepseek(key: ENV["DEEPSEEK_SECRET"]) },
        "google" => -> { LLM.google(key: ENV["GOOGLE_SECRET"]) },
        "openai" => -> { LLM.openai(key: ENV["OPENAI_SECRET"]) },
        "xai" => -> { LLM.xai(key: ENV["XAI_SECRET"]) }
      }.freeze

      def call
        PROVIDERS.each do |provider, build|
          Relay::Models::ModelInfo.replace!(provider, model_rows(build.call.persist!))
        end
      end

      private

      def model_rows(provider)
        provider.models.all.map {
          {
            model_id: _1.id,
            name: _1.name.to_s,
            chat: !!_1.chat?,
            data: _1.respond_to?(:to_h) ? _1.to_h : {}
          }
        }
      end
    end
  end
end
