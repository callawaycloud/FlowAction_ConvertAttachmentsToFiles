public with sharing class FlowAction_ConvertAttachmentsToFiles {
    /**
     * Flows cannot convert attachments to files b/c they do not support blobs
     */
    @InvocableMethod(label='Convert Attachments To Files')
    public static List<FlowOutput> convertAttachmentsToFiles(List<FlowInput> flowInputs) {
        List<Attachment> attachments = (List<Attachment>) flowInputs[0].attachments;

        // Query the existing attachments to be converted
        Map<Id, Attachment> attachmentIdToAttachment = new Map<Id, Attachment>(
            [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id IN :attachments]
        );

        // Convert the existing files to content versions
        Map<Id, ContentVersion> attachmentIdToContentVersion = new Map<Id, ContentVersion>();
        for (Attachment att : attachmentIdToAttachment.values()) {
            attachmentIdToContentVersion.put(
                att.Id,
                new ContentVersion(
                    Title = att.Name,
                    PathOnClient = att.Name + '.' + att.ContentType,
                    VersionData = att.Body
                )
            );
        }
        insert attachmentIdToContentVersion.values();

        // Query the new content versions to also get the content document id
        Map<Id, ContentVersion> mapContentVersionIdToContentVersion = new Map<Id, ContentVersion>(
            [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :attachmentIdToContentVersion.values()]
        );

        // Create the flow outputs that match the ordering of the flow inputs
        FlowOutput output = new FlowOutput();
        for (Attachment att : attachments) {
            ContentVersion cv = mapContentVersionIdToContentVersion.get(attachmentIdToContentVersion.get(att.Id).Id);

            output.contentVersionIds.add(cv.Id);
            output.contentDocumentIds.add(cv.ContentDocumentId);
        }
        return new List<FlowOutput>{ output };
    }

    public class FlowInput {
        @InvocableVariable(label='Attachment Records' required=true)
        public List<SObject> attachments = new List<SObject>();
    }

    public class FlowOutput {
        @InvocableVariable(label='ContentVersion Ids')
        public List<Id> contentVersionIds = new List<Id>();

        @InvocableVariable(label='ContentDocument Ids')
        public List<Id> contentDocumentIds = new List<Id>();
    }
}
