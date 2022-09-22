
$cash_box = {1=>0,2=>0,5=>0,10=>0,20=>0,50=>0,100=>0,200=>0,500=>0,2000=>0}
$users = {}
DENOMINATIONS = [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1]
$cashbox_total_amount = 0
$previous_total_amount = 0


def get_cashbox_amount
    for rupee in DENOMINATIONS
        puts "Enter the Amount of #{rupee} rs : "
        $cash_box[rupee] = gets.to_i
    end
    cashbox_total_amount_check()
    end

def cashbox_total_amount_check
    $cashbox_total_amount = $cash_box.map{|key,value| key*value}.sum
end

def cashbox_balance_amount_check(balance_to_give)
    balance_amount_in_cashbox = 0
     $cash_box.map {
      |cash_box_key, cash_box_value|
      if balance_to_give >= cash_box_key.to_i
        balance_amount_in_cashbox += cash_box_key.to_i * cash_box_value
      end
    }
    return balance_amount_in_cashbox
  end

def previous_total_amount_check
    $previous_total_amount = $cashbox_total_amount
end


def denomnination_for_user_amount(balance_to_give)
    denomination_given_to_user = {}
    DENOMINATIONS.map do
      |denomination_element|
      notes = balance_to_give / denomination_element
      if notes.nonzero?
        if $cash_box[denomination_element] > 0
          balance_to_give %=  denomination_element
  
          if $cash_box[denomination_element]>=notes
            $cash_box[denomination_element] -= notes
          else
            until $cash_box[denomination_element]==0
              $cash_box[denomination_element] -= 1
              notes-=1
            end
            balance_to_give = notes * denomination_element
          end
  
          denomination_given_to_user[denomination_element] = notes
  
          if cashbox_balance_amount_check(balance_to_give) < balance_to_give
            display_balance_not_available(balance_to_give,denomination_given_to_user)
            return {}
          end
        end
      end
    end
    return denomination_given_to_user
end
def billing_error
    puts "Billing error Insufficient balance in cash box"
    puts"Enter '1' to add amount to cashbox"
    get_cashbox_amount() if gets.to_i == 1
  end

  def display_balance_not_available(balance_to_give,denomination_given_to_user)
    puts "Cash Available in Cashbox to give is ",denomination_given_to_user
    puts "Cash Not Available in Cashbox : ",balance_to_give
  end

def complete_shopping_transaction(user_iteration)
    puts "Shopping Transaction"
    puts "Welcome User"
    puts "Enter the Product Amount : "
    product_amount = gets.to_i
    
begin
    puts "Enter the Amount you given in list : "
    user_amount = gets.chomp.split(",").map(&:to_i)
    given_amount = user_amount.reduce(:+)
    
    raise unless (user_amount.uniq - DENOMINATIONS).empty?
    raise if given_amount < product_amount
  rescue
    puts "Please enter the valid list along with comma(,) "
    retry
end
balance_to_give = given_amount - product_amount

  if $cashbox_total_amount<balance_to_give
    billing_error()
    return
  end

  if cashbox_balance_amount_check(balance_to_give) < balance_to_give
    billing_error()
    return
  end



    denomination_given_to_user = denomnination_for_user_amount(balance_to_give)

    if denomination_given_to_user.empty? and balance_to_give.nonzero?
        billing_error()
        return
    else
    user_amount.each {
        | each_amount |
          $cash_box[each_amount] += 1
      }
    $users["user#{user_iteration}"] = {
        "product_amount"=>product_amount,
        "given_amount"=>given_amount,
        "balance"=>balance_to_give,
        "user_amount" => user_amount
    }
    
    $users["user#{user_iteration}"].store("user_denomination",denomination_given_to_user)
    end
puts "Balance Giving Denomination : ",denomination_given_to_user
end



puts "#{'*'*50}"
puts "Billing Counter"

get_cashbox_amount()
previous_total_amount_check()
loop_iterate = 0
loop {
    loop_iterate+=1
    puts "'Enter' for Transaction and 'q' for Quit Transaction"
    user_choice = gets.chomp
    case user_choice
    when ''
        complete_shopping_transaction(loop_iterate)
    when 'q'
        break
    end
}
puts

$users.each {
    |user_name,user_details|
    print user_name," : ",user_details
    puts
  }
  puts
print "Final Cash Counter  #{$cash_box} ===> #{cashbox_total_amount_check}"
puts
