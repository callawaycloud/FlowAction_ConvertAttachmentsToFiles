# Flow Action - Convert Attachments to Files

At the time of writing this, flows are not able to handle blob data types.

This means we need an invocable apex method to handle the conversion of attachments to files within a flow.

## 📦 Install

**via sfdx-cli**
`sfdx force:package:install --package 0Ho5e00000000dtCAA -u your@org.user`

**via url**
login and navigate to [`/packaging/installPackage.apexp?p0=0Ho5e00000000dtCAA`](https://login.salesforce.com/packaging/installPackage.apexp?p0=0Ho5e00000000dtCAA). Choose `Install for: Admin Only`.

## 🔨 Usage

1. Create a flow
2. Query for the attachment records that need to be converted (ensure the Id is present)
3. Add an Action element and search for ``Convert Attachments to Files``
4. Send the attachment records to the action
5. Iterate over the returned ContentVersionIds or ContentDocumentIds

![Imgur](https://i.imgur.com/fSUXBzL.png)

## ✨Features

### Reusable

- Can be used from Flows, Processes, REST API

### Ordering

- The order of the returned ContentVersionIds and ContentDocumentIds are in the same order as the attachments sent to the invocable method

** Powered by ** [Callaway Cloud Consulting](https://www.callawaycloud.com/)