---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-10-02 01:15
# Definition

The reuse of a pre-trained model on a new problem. In transfer learning, a machine exploits the knowledge gained from a previous task to improve generalization about another. 

There are two main ways we can apply a pretrained model to a problem (here, in context of CNNs):
1. **Feature extraction**: use the convolutional base to do feature engineering on our images and then feed into a new densely connected classifier. 
2. **Fine-tune** a pretrained model and run end-to-end. 
# 1. Feature extraction

Use the the convolutional base to do feature engineering on our images and then feed into new densely connected classifier.
- most efficient
- does not require GPUs
- does not "personalize" feature extraction to the problem at hand
- likely leaves room for improvement
**Feature extraction** consists of using the representations learned by previous network to extract interesting features from new samples. These features are then run through a new classifier, which is trained from the scratch. 

For explanation, we will use VGG16 architecture, which is a simple and widely used convnet. Normally, we shall start with smaller models (i.e. VGG16, VGG19, Resnet34) and check out the data the model was built on and see how it aligns to our data. Most common is ImageNet, in this case.

Two ways forward:
1. **Fast extraction**
   - run the convnet over your data, record its output and use it as input to a Densely Connected Classifier (DCC)
   - fast and cheap to run
   - does not allow data augmentation
   - [[Example of fast feature extraction in CNN using transfer learning]]
2. **Extract & Augment**
   - Extend conv_base by adding dense layers on top and run the whole thing end to end
   - allows data augmentation
   - far more expensive
   - [[Example of extract & augment feature extraction in CNN using transfer learning]]

# 2. Fine-tuning a pretrained model

Here, we unfreeze a few of the convolutional base and allow those weights to be updated. Recall, early layers identify edges and shapes and later layers put these together to make higher order parts. The more our images deviate from the images used to create the pretrained model, the the more likely you will want to retrain the last few layers.
![][cv-cnn-finetuning-pretrained-model.jpg]
To fine-tune a pretrained model we should:
1. Add our custom network on top of an already-trained base network
2. Freeze the base network
3. Train the part we added
4. Unfreeze some layers in the base network
5. Jointly train both these layers and the part we added.
The example of such can be seen in [[Example of fine-tuning a pretrained CNN model using transfer learning]].
