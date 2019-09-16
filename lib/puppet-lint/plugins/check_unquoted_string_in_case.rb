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

def notify_tokens(type, sep_type, message)
  type_indexes(type).each do |kase|
    type_tokens = tokens[kase[:start]..kase[:end]]
    type_tokens.index do |r|
      if r.type == sep_type
        s = r.prev_token
        while (s.type != :NEWLINE) && (s.type != :LBRACE)
          if (s.type == :NAME || s.type == :CLASSREF) && (s.type != :TYPE)
            notify :warning, {
              :message => message,
              :line    => s.line,
              :column  => s.column,
              :token   => s,
            }
          end
          s = s.prev_token
        end
      end
    end
  end
end

PuppetLint.new_check(:unquoted_string_in_case) do
  def check
    notify_tokens(:CASE, :COLON, 'unquoted string in case')
  end 

  def fix(problem)
    problem[:token].type = :SSTRING
  end
end

PuppetLint.new_check(:unquoted_string_in_selector) do
  def check
    notify_tokens(:QMARK, :FARROW, 'unquoted string in selector')
  end 

  def fix(problem)
    problem[:token].type = :SSTRING
  end
end
