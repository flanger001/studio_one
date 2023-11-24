# frozen_string_literal: true

require "test_helper"

class TestConfiguration < Minitest::Test
  def test_configure_takes_a_block
    config = StudioOne::Configuration.configure do |c|
      c.source_directory = "/home/test"
    end
    assert_equal(config.source_directory, "/home/test")
  end

  def test_configure_does_not_need_a_block
    config = StudioOne::Configuration.configure
    config.source_directory = "/home/test"
    assert_equal(config.source_directory, "/home/test")
  end

  def test_knows_relative_paths
    config = StudioOne::Configuration.new

    config.source_directory = "./test"
    config.target_directory = "./out"

    assert_equal(config.source_directory_full, File.expand_path("./test"))
    assert_equal(config.parent_directory, File.expand_path("."))
    assert_equal(config.target_directory_full, File.expand_path("./out"))
    assert_equal(config.base_directory, "test")
  end

  def test_source_path_must_exist
    config = StudioOne::Configuration.new

    config.source_directory = "./grup"
    assert_raises(Errno::ENOENT) { config.source_directory_full }
  end

  # def test_suffix_default_is_empty
  #   config = StudioOne::Configuration.new

  #   config.source_directory = "./test"
  #   assert_equal(config.suffix, "")
  # end

  # def test_suffix_false_is_empty
  #   config = StudioOne::Configuration.new

  #   config.source_directory = "./test"
  #   config.suffix = false

  #   assert_equal(config.suffix, "")
  # end

  # def test_suffix_true_is_base_filename
  #   config = StudioOne::Configuration.new

  #   config.source_directory = "./test"
  #   config.suffix = true

  #   assert_equal(config.suffix, "test")
  # end

  # def test_suffix_can_be_string
  #   config = StudioOne::Configuration.new

  #   config.source_directory = "./test"
  #   config.suffix = "Live at Jake's"

  #   assert_equal(config.suffix, "Live at Jake's")
  # end
end
