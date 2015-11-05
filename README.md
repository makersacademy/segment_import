# Segment import script

This script exports people and event data from Mixpanel, and newsletter data
from Mailchimp and enters them into Segment

To upload, make sure you have a `.env` file (there's a secure note in
lastpass called **Segment Import .env** with the values you'll need)
and all of the integrations you want segment to import to (Customer.io for now)
are switched on, and then run the bash script

```
sh export.sh
```

There are additional instructions in that export.sh file for what you need to do
to get things working


