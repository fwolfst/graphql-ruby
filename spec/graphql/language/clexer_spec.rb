# frozen_string_literal: true
require "spec_helper"
require_relative "./lexer_examples"

if defined?(GraphQL::CParser::Lexer)
  describe GraphQL::CParser::Lexer do
    subject { GraphQL::CParser::Lexer }

    it "makes tokens like the other lexer" do
      str = "{ f1(type: \"str\") ...F2 }\nfragment F2 on SomeType { f2 }"
      # Don't include prev_token here
      tokens = GraphQL.scan_with_c(str).map { |t| [*t.first(4), t[3].encoding] }
      old_tokens = GraphQL.scan_with_ruby(str).map { |t| [*t.first(4), t[3].encoding] }

      assert_equal [
        [:LCURLY, 1, 1, "{", Encoding::UTF_8],
        [:IDENTIFIER, 1, 3, "f1", Encoding::UTF_8],
        [:LPAREN, 1, 5, "(", Encoding::UTF_8],
        [:TYPE, 1, 6, "type", Encoding::UTF_8],
        [:COLON, 1, 10, ":", Encoding::UTF_8],
        [:STRING, 1, 12, "str", Encoding::UTF_8],
        [:RPAREN, 1, 17, ")", Encoding::UTF_8],
        [:ELLIPSIS, 1, 19, "...", Encoding::UTF_8],
        [:IDENTIFIER, 1, 22, "F2", Encoding::UTF_8],
        [:RCURLY, 1, 25, "}", Encoding::UTF_8],
        [:FRAGMENT, 2, 1, "fragment", Encoding::UTF_8],
        [:IDENTIFIER, 2, 10, "F2", Encoding::UTF_8],
        [:ON, 2, 13, "on", Encoding::UTF_8],
        [:IDENTIFIER, 2, 16, "SomeType", Encoding::UTF_8],
        [:LCURLY, 2, 25, "{", Encoding::UTF_8],
        [:IDENTIFIER, 2, 27, "f2", Encoding::UTF_8],
        [:RCURLY, 2, 30, "}", Encoding::UTF_8]
      ], tokens
      assert_equal(old_tokens, tokens)
    end

    include LexerExamples
  end
end
