module Relay::Tools
  ##
  # The {Relay::Tools::RelayKnowledge} tool provides the LLM
  # with knowledge about Relay through its README documentation.
  # This helps inform the LLM what about Relay is and what it does,
  # since it is unlikely to be heard of by an LLM.
  class RelayKnowledge < Base
    name 'relay-knowledge'
    description 'Returns knowledge about Relay and llm.rb'
    param :topic, Enum["relay", "llm.rb"], "The knowledge topic", required: true

    ##
    # Provides the Relay documentation
    # @return [Hash]
    def call(topic:)
      case topic
      when "relay" then {documentation: relay_documentation}
      when "llm.rb" then {documentation: llmrb_documentation}
      else {error: "unknown topic: #{topic}"}
      end
    rescue SystemCallError
      {error: "file not found"}
    end

    private

    def relay_documentation
      docs = File.join(Relay.root, "README.md")
      File.read(docs)
    end

    def llmrb_documentation
      docs = File.join(Relay.root, "..", "llm.rb", "README.md")
      File.read(docs)
    end
  end
end
