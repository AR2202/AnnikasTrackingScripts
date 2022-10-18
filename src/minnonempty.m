function m = minnonempty(num1, num2)
if isempty(num2)
    m = num1;
    
else
    m = min(num1, num2);
end