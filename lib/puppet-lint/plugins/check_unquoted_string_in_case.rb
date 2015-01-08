require 'pp'

def type_indexes(type)
  type_indexes = []
  tokens.each_index do |token_idx|
    if tokens[token_idx].type == type
      depth = 0
      tokens[(token_idx + 1)..-1].each_index do |case_token_idx|
        idx = case_token_idx + token_idx + 1
        if tokens[idx].type == :LBRACE
          depth += 1
        elsif tokens[idx].type == :RBRACE
          depth -= 1
          if depth == 0
            type_indexes << {:start => token_idx, :end => idx}
            break
          end
        end
      end
    end
  end
  type_indexes
end

def tokens_to_fix(type_tokens, sep_type)
  tokens_to_fix = []
  type_tokens.index do |r|
    if r.type == sep_type
      s = r.prev_token
      while s.type != :NEWLINE and s.type != :LBRACE
        if s.type == :NAME || s.type == :CLASSREF
          tokens_to_fix << s
        end
        s = s.prev_token
      end
    end
  end
  tokens_to_fix
end

def act_on_tokens(type, sep_type, &block)
  type_indexes(type).each do |kase|
    case_tokens = tokens[kase[:start]..kase[:end]]

    tokens_to_fix(case_tokens, sep_type).each do |r|
      block.call(r)
    end
  end
end

PuppetLint.new_check(:unquoted_string_in_case) do

  def check
    act_on_tokens(:CASE, :COLON) do |r|
      notify :warning, {
        :message => 'unquoted string in case',
        :line    => r.line,
        :column  => r.column,
        :token   => r,
      }
    end
  end 

  def fix(problem)
    problem[:token].type = :SSTRING
  end
end

PuppetLint.new_check(:unquoted_string_in_selector) do

  def check
    act_on_tokens(:QMARK, :FARROW) do |r|
      notify :warning, {
        :message => 'unquoted string in selector',
        :line    => r.line,
        :column  => r.column,
        :token   => r,
      }
    end
  end 

  def fix(problem)
    problem[:token].type = :SSTRING
  end
end
