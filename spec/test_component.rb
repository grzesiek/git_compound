# GitCompound::Component wrapper class
#
# Supports setting up test environment and
# delegates methods to @component
#
class TestComponent
  attr_reader :component, :metadata

  def initialize(name, path, metadata = {})
    @component = GitCompound::Component.new(name) do
      branch 'master'
      source path
      destination name + '_built'
    end

    @metadata = metadata
  end

  def add_metadata(metadata)
    @metadata.merge!(metadata)
  end

  def method_missing(name, *params, &block)
    @component.public_send(name, *params, &block)
  end
end
