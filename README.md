# Segment import scripts

A set of (very hacky) scripts used for importing data into segment, these
shouldn't be used very often.

If you need to update all the segment data from Pipedrive follow these steps:

1. Go to [Pipedrive](https://makersacademy.pipedrive.com/deals/filter/208) and
   export all the users as a CSV (using the button on the right hand side)
1. Move the download to the current folder, and rename it as `people_export.csv`
1. Run the script `ruby pipedrive_people_update.rb`


## Old import script (no longer used)

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


