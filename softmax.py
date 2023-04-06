import numpy as np 

def MySoftmax(x):
  exponents=np.exp(x)
  total = exponents.sum()
  return exponents/total

output1 = MySoftmax([-3,0.7,2.1,4.9])
print("The Softmax values of [-3,0.7,2.1,4.9] are " + str(output1)) 

output2 = MySoftmax([-12.5,5,1,23.4])
print("The Softmax values of [-12.5,5,1,23.4] are " + str(output2))

