require 'pp'

PuppetLint.new_check(:unquoted_string_in_case) do

  def case_indexes
    case_indexes = []
    tokens.each_index do |token_idx|
      if tokens[token_idx].type == :CASE
        depth = 0
        tokens[(token_idx + 1)..-1].each_index do |case_token_idx|
          idx = case_token_idx + token_idx + 1
          if tokens[idx].type == :LBRACE
            depth += 1
          elsif tokens[idx].type == :RBRACE
            depth -= 1
            if depth == 0
              case_indexes << {:start => token_idx, :end => idx}
              break
            end
          end
        end
      end
    end
    case_indexes
  end

  def tokens_to_fix(case_tokens)
    tokens_to_fix = []
    case_tokens.index do |r|
      if r.type == :COLON
        s = r.prev_token
        while s.type != :NEWLINE
          if s.type == :NAME || s.type == :CLASSREF
            tokens_to_fix << s
          end
          s = s.prev_token
        end
      end
    end
    tokens_to_fix
  end

  def act_on_tokens(&block)
    case_indexes.each do |kase|
      case_tokens = tokens[kase[:start]..kase[:end]]

      tokens_to_fix(case_tokens).each do |r|
        block.call(r)
      end
    end
  end

  def check
    act_on_tokens do |r|
      notify :warning, {
        :message => 'unquoted string in case',
        :line    => r.line,
        :column  => r.column,
      }
    end
  end 

  def fix(problem)
    act_on_tokens do |r|
      r.type = :SSTRING
    end
  end
end

PuppetLint.new_check(:unquoted_string_in_selector) do

  def check
    qmark_indexes = []

    tokens.each_index do |token_idx|
      if tokens[token_idx].type == :QMARK
        depth = 0
        tokens[(token_idx + 1)..-1].each_index do |case_token_idx|
          idx = case_token_idx + token_idx + 1
          if tokens[idx].type == :LBRACE
            depth += 1
          elsif tokens[idx].type == :RBRACE
            depth -= 1
            if depth == 0
              qmark_indexes << {:start => token_idx, :end => idx}
              break
            end
          end
        end
      end
    end

    qmark_indexes.each do |kase|
      qmark_tokens = tokens[kase[:start]..kase[:end]]

      if qmark_tokens.index { |r| r.type == :NAME || r.type == :CLASSREF }
        notify :warning, {
          :message => 'unquoted string in selector',
          :line    => qmark_tokens.first.line,
          :column  => qmark_tokens.first.column,
        }
      end
    end
  end 

  def fix(problem)
    qmark_indexes = []

    tokens.each_index do |token_idx|
      if tokens[token_idx].type == :QMARK
        depth = 0
        tokens[(token_idx + 1)..-1].each_index do |case_token_idx|
          idx = case_token_idx + token_idx + 1
          if tokens[idx].type == :LBRACE
            depth += 1
          elsif tokens[idx].type == :RBRACE
            depth -= 1
            if depth == 0
              qmark_indexes << {:start => token_idx, :end => idx}
              break
            end
          end
        end
      end
    end

    qmark_indexes.each do |kase|
      qmark_tokens = tokens[kase[:start]..kase[:end]]

      qmark_tokens.index { |r| r.type = :SSTRING if r.type == :NAME || r.type == :CLASSREF }
    end
  end
end
