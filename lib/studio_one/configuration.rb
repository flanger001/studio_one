# frozen_string_literal: true

module StudioOne
  class Configuration
    class << self
      def configure
        new.tap
        yield(instance) if block_given?
        instance
      end
    end

    def initialize
      @suffix = ""
      @number_files = false
    end

    attr_accessor :source_directory, :target_directory, :number_files, :command
    attr_reader :suffix

    def source_directory_full
      @source_directory_full ||= File.realpath(source_directory)
    end

    def target_directory_full
      @target_directory_full ||= File.expand_path(target_directory)
    end

    def parent_directory
      @parent_directory ||= File.dirname(source_directory_full, 1)
    end

    def base_directory
      @base_directory ||= File.basename(source_directory_full)
    end
  end
end
