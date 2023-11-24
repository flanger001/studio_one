# frozen_string_literal: true

require "fileutils"

module StudioOne
  class Runner
    attr_reader :config
    def initialize(config)
      @config = config
      @command = resolve_command
    end

    def run
      @command.new(config).run
    end

    def resolve_command
      case config.command
      when "batch-rename"
        Commands::BatchRename
      when "clone"
        Commands::Clone
      else
        raise
      end
    end
  end
end
