require 'date'

def isDate(string)
    begin
        Date.parse(string)
        return true
    rescue => exception
        return false
    end
end

def isInteger(string)
    string.class == 1.class
end

def isString(string)
    string.class == "string".class
end

def getOperandType(operand)
    
    if isDate(operand)
        return "Date"
    elsif isString(operand)
        return "String"
    elsif isInteger(operand)
        return "Integer"
    end
end

$isEqual = "isEqual"
$isNotEqual = "isNotEqual"
#---------------------------------------------
$isMoreThan = "isMoreThan"
$isNotMoreThan = "isNotMoreThan"
#---------------------------------------------
$isLessThan = "isLessThan"
$isNotLessThan = "isNotLessThan"
#---------------------------------------------
$isNotLessThanOrEqual = "isNotLessThanOrEqual"
$isMoreThanOrEqual = "isMoreThanOrEqual"
#---------------------------------------------
$isNotMoreThanOrEqual = "isNotMoreThanOrEqual"
$isLessThanOrEqual = "isLessThanOrEqual"
#---------------------------------------------
$inInclusiveRange = "inInclusiveRange"
$inExclusiveRange = "inExclusiveRange"
#---------------------------------------------
$startsWith = "startsWith"
$endsWith = "endsWith"
#---------------------------------------------
$contains = "contains"
$doesNotContains = "doesNotContains"
#---------------------------------------------


def solve_condition(left_operand, operator, right_operand)

    # left_operand will always have a singular-value, hence used to determine the operand type
    
    operand_type = operand_type = getOperandType(left_operand)
    
    case operand_type
        #---------------------------------------
        when "Integer"
            
            case operator
            when $isEqual
                left_operand == right_operand
            
            when $isNotEqual
                left_operand != right_operand
        
            when $isMoreThan, $isNotLessThanOrEqual
                left_operand > right_operand
        
            when $isMoreThanOrEqual, $isNotLessThan
                left_operand >= right_operand
            
            when $isLessThan, $isNotMoreThanOrEqual
                left_operand < right_operand
                
            when $isLessThanOrEqual, $isNotMoreThan
                left_operand <= right_operand
    
            when $inInclusiveRange
                # right_operand in this case would be a string i.e "100 1000" 
                low, high = right_operand.split.map{ |string| string.to_i}
                left_operand >= low && left_operand <= high
    
            when $inExclusiveRange
                # right_operand in this case would be a string i.e "100 1000" 
                low, high = right_operand.split.map{ |string| string.to_i}
                left_operand > low && left_operand < high
            end
        #---------------------------------------
        when "String"

            case operator
            when $isEqual
                left_operand == right_operand
    
            when $isNotEqual
                left_operand != right_operand
    
            when $startsWith
                left_operand.start_with?(right_operand)
    
            when $endsWith
                left_operand.end_with?(right_operand)
    
            when $contains
                left_operand.include?(right_operand)
            
            when $doesNotContains
                !left_operand.include?(right_operand)
            end
        #---------------------------------------
        when "Date"
            # Date format --> "YYYY-MM-DD"
            left_date = Date.parse(left_operand)
            right_date = Date.parse(right_operand)
            case operator
                
            when $isEqual                
                left_date == right_date
    
            when $isNotEqual
                left_date != right_date
    
            when $isLessThan, $isNotMoreThanOrEqual
                left_date < right_date
    
            when $isLessThanOrEqual, $isNotMoreThan
                left_date <= right_date

            when $isMoreThan, $isNotLessThanOrEqual
                left_date > right_date
                
            when $isMoreThanOrEqual, $isNotLessThan
                left_date > right_date
    
            when $inInclusiveRange
                # right_operand in this case would be a string i.e "2022-01-19 2022-01-22"
                startDate, endDate = right_operand.to_s.split.map{ |string| Date.parse(string) }
                left_date > startDate && left_date < endDate
            
            when $inExclusiveRange
                # right_operand in this case would be a string i.e "2022-01-19 2022-01-22"
                startDate, endDate = right_operand.to_s.split.map{ |string| Date.parse(string) }
                left_date >= startDate && left_date <= endDate
     
            end
        end       
  end

  

  # # Integers
# puts solve_condition(5, $isEqual, 5)

# # Strings
# puts solve_condition("All the best", $contains, "best")

# # Dates: format--> "YYYY-MM-DD"
# puts solve_condition("2022-01-21", $isEqual, "2022-01-20")
# puts solve_condition("2022-01-20", $inInclusiveRange, "2022-01-15 2022-01-30")