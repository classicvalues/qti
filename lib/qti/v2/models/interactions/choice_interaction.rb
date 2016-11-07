require 'qti/v2/models/base'
require 'qti/v2/models/choices/simple_choice'

module Qti
  module V2
    module Models
      module Interactions
        class ChoiceInteraction < Qti::V2::Models::Base
          NODE_NAME = 'choiceInteraction'.freeze
          # This will know if a class matches
          def self.matches(node)
            matches = node.children.filter(INTERACTION_ELEMENTS_CSS).select { |n| n.name == NODE_NAME }
            return false if matches.empty?

            raise Qti::UnsupportedSchema if matches.size > 1
            new(matches.first)
          end

          def initialize(node)
            @node = node
          end

          def shuffled?
            @node.attributes['shuffle'].value == 'true'
          end

          def answers
            @answers ||= answer_nodes.map do |node|
              V2::Models::Choices::SimpleChoice.new(node)
            end
          end

          def max_choices_count
            @node.attributes['maxChoices']&.value&.to_i
          end

          def min_choices_count
            @node.attributes['minChoices']&.value&.to_i
          end

          private

          def answer_nodes
            @node.children.filter('simpleChoice')
          end
        end
      end
    end
  end
end