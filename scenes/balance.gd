extends Node

var balance = 10000

func get_balance() -> int:
	return balance
	
func set_balance(v: int):
	balance = v

func minus_balance(v: int):
	var res = balance - v
	if res >= 0:
		set_balance(res)
		
func plus_balance(v: int):
	set_balance(balance + v)
	
