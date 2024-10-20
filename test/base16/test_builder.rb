# frozen_string_literal: true

require "test_helper"

class Base16::TestBuilder < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Base16::Builder::VERSION
  end
end
