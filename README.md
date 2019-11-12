Universal Track Manager, also known as UTM, is a gem to track your visitors and their pageloads. You can track simple information like browser, IP address, viewport screensize, and your inbound UTM parameters. 

If the user logs in, you can associate the visit to a user id.

Visits are a lot like Rails sessions; in fact, this Gem piggybacks off of Rails sessions for tracking the visit. (You will need to have a session store set up and in place.)

A visit also stores the first and last time the visitor came during that visit. However, since visits may share sessions, a visit is made unique by any of:

• A new session

Even within the same Rails session, a visit can be defined unique by: 

• A new logical day*
• A new or different browser
• A new or different IP address


???
• A new or different viewport size (unless the viewport size is a reverse )

# Name Conflicts

UTM will create tables named `browsers`, `utms`, `visits`.



