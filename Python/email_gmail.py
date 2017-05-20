import smtplib  
  
fromaddr = 'charcooal@gmail.com'  
toaddrs  = 'charliemehrer@gmail.com'  
msg = 'There was a terrible error that occured and I wanted you to know!'  
  
# Credentials (if needed)  
username = 'charcooal'  
password = 'wyqej3y434'  
  
# The actual mail send  
server = smtplib.SMTP('smtp.gmail.com:587')  
server.starttls()  
server.login(username,password)  
server.sendmail(fromaddr, toaddrs, msg)  
server.quit()  