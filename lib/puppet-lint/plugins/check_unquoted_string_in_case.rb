require 'pp'

PuppetLint.new_check(:unquoted_string_in_case) do

  def check
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

    case_indexes.each do |kase|
      case_tokens = tokens[kase[:start]..kase[:end]]

      if case_tokens.index { |r| r.type == :NAME || r.type == :CLASSREF }
        notify :warning, {
          :message => 'expected quoted string in case',
          :line    => case_tokens.first.line,
          :column  => case_tokens.first.column,
        }
      end
    end
  end 

  def fix(problem)
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

    case_indexes.each do |kase|
      case_tokens = tokens[kase[:start]..kase[:end]]

      case_tokens.index { |r| r.type = :SSTRING if r.type == :NAME || r.type == :CLASSREF }
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
          :message => 'expected quoted string in selector',
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
