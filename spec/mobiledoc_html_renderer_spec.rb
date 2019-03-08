require 'spec_helper'

include Mobiledoc::Utils::SectionTypes
include Mobiledoc::Utils::MarkerTypes

describe Mobiledoc::HTMLRenderer do

  it 'has a version number' do
    expect(Mobiledoc::HTMLRenderer::VERSION).not_to be nil
  end

  it 'can be instantiated' do
    expect { described_class.new }.to_not raise_exception
  end

  describe '#render' do
    it 'makes it easy to get raw text from a mobiledoc' do
      expected_value = 'Bob'

      atom = Module.new do
        module_function

        def name
          'hello-atom'
        end

        def type
          'html'
        end

        def render(env, value, payload, options)
          "Hello #{value}"
        end
      end

      mobiledoc = {
        'version' => '0.3.1',
        'atoms' => [
          ['hello-atom', 'Bob', {}]
        ],
        'cards' => [],
        'markups' => [],
        'sections' => [
          [MARKUP_SECTION_TYPE, 'P', [
            [MARKUP_MARKER_TYPE, [], 0, 'Greeting: '],
            [ATOM_MARKER_TYPE, [], 0, 0]]
          ],
          [MARKUP_SECTION_TYPE, 'P', [
            [MARKUP_MARKER_TYPE, [], 0, 'Another line']]
          ]
        ]
      }


      renderer = Mobiledoc::HTMLRenderer.new(atoms: [atom])
      text = renderer.render_text(mobiledoc)

      expect(text).to eq("Greeting: Hello Bob\nAnother line")
    end

  end
end
