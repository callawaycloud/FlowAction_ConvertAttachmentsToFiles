@IsTest
private class FlowAction_ConvertAttachmentsToFilesTest {
    private static Integer amountOfAttachmentsToTestWith = 5;

    @IsTest
    private static void createFileTest() {
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;

        // Create the test attachments
        List<Attachment> testAttachments = createAttachments(testAccount1.Id);

        // Create an instance of flow inputs
        FlowAction_ConvertAttachmentsToFiles.FlowInput flowInput = new FlowAction_ConvertAttachmentsToFiles.FlowInput();
        flowInput.attachments = testAttachments;

        // Create the list of flow inputs to send to constructor
        List<FlowAction_ConvertAttachmentsToFiles.FlowInput> flowInputs = new List<FlowAction_ConvertAttachmentsToFiles.FlowInput>{};
        flowInputs.add(flowInput);

        Test.startTest();
        FlowAction_ConvertAttachmentsToFiles.FlowOutput[] flowOutputs = FlowAction_ConvertAttachmentsToFiles.convertAttachmentsToFiles(
            flowInputs
        );
        Test.stopTest();

        System.assertEquals(1, flowOutputs.size(), 'Expected 1 set of flow results returned');
        System.assertEquals(
            amountOfAttachmentsToTestWith,
            flowOutputs[0].ContentVersionIds.size(),
            'We did not get a content version id for each attachment'
        );
        System.assertEquals(
            amountOfAttachmentsToTestWith,
            flowOutputs[0].ContentDocumentIds.size(),
            'We did not get a content document id for each attachment'
        );
    }

    private static List<Attachment> createAttachments(Id parentId) {
        List<Attachment> testAttachments = new List<Attachment>();
        for (Integer i = 0; i < amountOfAttachmentsToTestWith; i++) {
            String attachmentNameAndBody = 'Test Attachment ' + String.valueOf(i);

            testAttachments.add(
                new Attachment(
                    Name = attachmentNameAndBody,
                    Body = Blob.valueOf(attachmentNameAndBody),
                    ParentId = parentId
                )
            );
        }
        insert testAttachments;
        return testAttachments;
    }
}
