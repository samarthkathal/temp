require "./helper_functions.rb"

  #---------------------------------------------------------
  #-- Below funtions does logical operation on an array ----
  def glue_it(glue, arr)
    result = arr[0]
    arr.each do |value|
        if glue == "AND"
            result = result && value
        elsif glue == "OR"
            result = result || value    
        end
    end
    return result
  end

  #---------------------------------------------------------
  def solve_leaf_condition(condition, payload)
    # left_operand  --> value in payload(data from trigger) for the key mentioned in condition (campaign condition) 
    # right_operand --> value in campaign that is being compared with left_operand
    left_operand = payload[condition['key']] 
    operator = condition["operator"]
    right_operand = condition['value']

    return solve_condition(left_operand, operator, right_operand) #imported function      
  end

  #---------------------------------------------------------
  # Below function solves array of all conditions and, glues it with the glue provided
  def solve_leaf_condition_array( arr, payload)
    logic_array = []
    arr.each do |condition|
        logic_array << solve_leaf_condition(condition, payload)
    end

    return logic_array
  end

  #---------------------------------------------------------
  # Below function checks if the conditions array consists of all leaf conditions
  def is_a_leaf_condition_array(arr)
    if arr.size.positive?
        if arr[0]['conditions'].nil?
            # call a leaf condition solving function
            # it is a leaf condition array
            return true
        else
            # reiterate over this object again for leaf condition array
            # it is not a leaf condition
            return false
        end
    else
        puts "The conditions array is empty"
        # There won't be any empty condition arrays 
        # i.e there are no conditions 
    end
  end

  #---------------------------------------------------------
  def parse(conditions, payload)   
    if !is_a_leaf_condition_array(conditions)
        logic_arr = []
        conditions.each do |condition|
            glue  = condition['glue']
            arr_to_glue = parse(condition['conditions'], payload)
            logic_arr << glue_it(glue,arr_to_glue)
        end
        
        return logic_arr
    else
        #returns array of logical results of leaf conditions array  
        return solve_leaf_condition_array(conditions, payload)  
    end
  end

  #---------------------------------------------------------
  def evaluate(campaign, trigger)
    payload = trigger['payload']
    return parse(campaign["conditions"], payload)[0]
  end

  #---------------------------------------------------------
  def handle_trigger(trigger)
    # This function should deal with trigger types
  end

  #---------------------------------------------------------

# Req--> header --> https://pipedrive.thrillophilia.com
# Source --> pipedrive
# Incoming deal/trigger
trigger = {
    "trigger_type" => "deal_initiated",
    "payload" => { 
        "tour_location" => "Gujrat",
        "DOJ" => "2022-01-20",
        "deal_amount"=> 5000,
        "no_of_passengers" => 5, 
        "discount_offered" => 1500, 
        "discount_coupon"=> "GUJ_TOUR"
     }
}

# conditions that are set in campaign

campaign1 = {
    "source_code" => "PDrive",
    
    "trigger_type" => "deal_initiated",
    "conditions" => [{
        "glue"=> "AND",   # [T, T] -->  T
        "conditions" => [
          {   
              "glue"=> "AND",  #[T,T,T] --> T
              "conditions"=> [
                {  
                  "key" => "tour_location", # T
                  "operator"=> "startsWith",
                  "value"=> "G"
                },
                { 
                  "key" => "no_of_passengers",    # T
                  "operator" => "inInclusiveRange",
                  "value" => "1 10"
                },
                { 
                  "key" => "DOJ",    # T
                  "operator" => "isLessThan",
                  "value" => "2022-01-21"
                },
              ]
          },      
          {
              "glue" => "AND",    #[T,T] --> T
              "conditions" => 
              [{ 
                  "key" => "no_of_passengers",    # T
                  "operator" => "isLessThanOrEqual",
                  "value" => 5
              },
              {
                  "key" => "deal_amount", # T
                  "operator" => "inExclusiveRange",
                  "value" => "1200 5001"
              }]
          }
          ]
    }]
}

campaign2 = {
    "source_code" => "PDrive",
    "trigger_type" => "deal_initiated",
    "conditions" => [{
        "glue"=> "AND",   # [T, F, T] -->  F
        "conditions" => [
          {   
              "glue"=> "OR",  #[T,T] --> T 
              "conditions"=> [
                {  
                  "key" => "tour_location", # T
                  "operator"=> "isNotEqual",
                  "value"=> "Assam"
                },
                { 
                  "key" => "no_of_passengers",    # T
                  "operator" => "isLessThan",
                  "value" => 10
              },
              ]
          },      
          {
              "glue" => "AND",    #[T,F] --> F
              "conditions" => 
              [{ 
                  "key" => "no_of_passengers",    # T
                  "operator" => "isMoreThan",
                  "value" => 1
              },
              {
                  "key" => "deal_amount", # F
                  "operator" => "isMoreThanOrEqual",
                  "value" => 10000
              }]
          },
          {
            "glue" => "OR",    #[F,T] --> T
            "conditions" => 
            [{ 
                "key" => "discount_offered",    # F
                "operator" => "isMoreThan",
                "value" => 2000
            },
            {
                "key" => "discount_coupon", # T
                "operator" => "isEqual",
                "value" => "GUJ_TOUR"
            }]
        }
        ]
    }]
}

campaign3 = {
    "source_code" => "PDrive",
    "trigger_type" => "deal_initiated",
    "conditions" => [{
        "glue"=> "AND",   # [T, T, T] -->  T
        "conditions" => [
          {   
              "glue"=> "OR",  #[T,T] --> T 
              "conditions"=> [
                {  
                  "key" => "tour_location", # T
                  "operator"=> "isNotEqual",
                  "value"=> "Assam"
                },
                { 
                  "key" => "no_of_passengers",    # T
                  "operator" => "isLessThan",
                  "value" => 10
              },
              ]
          },      
          {
              "glue" => "OR",    #[T,F] --> T
              "conditions" => 
              [{ 
                  "key" => "no_of_passengers",    # T
                  "operator" => "isMoreThan",
                  "value" => 1
              },
              {
                  "key" => "deal_amount", # F
                  "operator" => "isMoreThanOrEqual",
                  "value" => 10000
              }]
          },
          {
            "glue" => "OR",    #[T] --> T
            "conditions" => 
            [{
                "glue"=> "AND",   # [T, T] -->  T
                "conditions" => [
                  {   
                      "glue"=> "OR",  #[F,T] --> T 
                      "conditions"=> [
                        {  
                          "key" => "tour_location", # F
                          "operator"=> "isEqual",
                          "value"=> "Assam"
                        },
                        { 
                          "key" => "no_of_passengers",    # T
                          "operator" => "isLessThan",
                          "value" => 10
                      },
                      ]
                  },      
                  {
                      "glue" => "AND",    #[T,T] --> T
                      "conditions" => 
                      [{ 
                          "key" => "no_of_passengers",    # T
                          "operator" => "isEqual",
                          "value" => 5
                      },
                      {
                          "key" => "deal_amount", # T
                          "operator" => "isLessThan",
                          "value" => 10000
                      }]
                  }
                ]
            }]
        }
        ]
    }]
}
  
puts evaluate(campaign1, trigger)
# puts evaluate(campaign2, trigger)
# puts evaluate(campaign3, trigger)


