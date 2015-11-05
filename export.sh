# First download mailchimp newsletter here:
# https://us7.admin.mailchimp.com/lists/exports?id=151305
# and save it as "mailchimp_export.csv"
# Then switch over to segment on all the sites

# You need to install dotenv as a dependency for python
# pip install -U python-dotenv

echo "exporting all people from mixpanel"
python people_export.py
echo "uploading people"
ruby mixpanel_people_upload.rb

echo "uploading newsletter subscribers"
ruby newsletter_upload.rb

echo "uploading mixpanel events"
ruby mixpanel_event_upload.rb

echo "done!"
