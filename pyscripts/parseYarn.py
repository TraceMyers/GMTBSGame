import sys
import os


class DialogueItem:
    def __init__(self):
        self.charName = None
        self.nodeID = None
        self.text = ''
        self.links = []

        # for tree testing
        self.edges = [] 
        self.allEdgesSearched = False

    def __repr__(self):
        return f'name: {self.charName}\nID: {self.nodeID}\ntext: {self.text}\nlinks: {self.links}\n-----'


class DialogueTree:
    def __init__(self):
        self.root = None
        self.end = None


def addItem(curDialogueItem, dialogueItems, warnings):
    if curDialogueItem.charName is not None \
    and curDialogueItem.nodeID is not None \
    and (curDialogueItem.charName.lower() == 'end' or curDialogueItem.charName.lower() == 'start' or curDialogueItem.text != '') \
    and (curDialogueItem.charName.lower() == 'end' or len(curDialogueItem.links) > 0):
        print(f'===========\nADDING ITEM\n===========')
        print(curDialogueItem)
        dialogueItems.append(curDialogueItem)
        if curDialogueItem.charName.lower() == 'end':
            endAdded = True
        elif curDialogueItem.charName.lower() == 'start':
            startAdded = True
        return True
    else:
        warnings.append(f'!! Warning !! item not added to tree:\n{curDialogueItem}\n')
        return False



def parseFile(fileName, warnings):
    dialogueItems = []
    file = open(fileName, 'r')
    curDialogueItem = None
    names = fileName.split('_')[:2]
    thisLineIsDialogue = False
    startAdded = False
    endAdded = False

    print('\n============================== Parsing File ==============================\n')
    for line in file:
        if 'title' in line:
            thisLineIsDialogue = False
            if curDialogueItem is not None:
                itemAdded = addItem(curDialogueItem, dialogueItems, warnings)
                if itemAdded:
                    if curDialogueItem.charName.lower() == 'end':
                        endAdded = True
                    elif curDialogueItem.charName.lower() == 'start':
                        startAdded = True
            curDialogueItem = DialogueItem()

            nameAndID = line[line.find(':') + 1:].split('-')
            nameAndID = [item.strip() for item in nameAndID]
            if nameAndID[0].lower() not in names:
                warnings.append(f'!! Warning !! character name not in fileName: {nameAndID[0]}')
            curDialogueItem.charName = nameAndID[0]
            curDialogueItem.nodeID = nameAndID[1]
        elif '---' in line:
            thisLineIsDialogue = True
        elif thisLineIsDialogue:
            if '[[' in line:
                thisLineIsDialogue = False
                curDialogueItem.text = curDialogueItem.text.strip()
                linkItems = line.split('|')
                for linkItem in linkItems[1:]:
                    links = linkItem.split(']')
                    print(links)
                    links = links[0].split('-')
                    links = [item.strip() for item in links]
                    curDialogueItem.links.append((links[0], links[1]))
            else:
                curDialogueItem.text += line
    if curDialogueItem is not None:
        itemAdded = addItem(curDialogueItem, dialogueItems, warnings)
        if itemAdded:
            if curDialogueItem.charName.lower() == 'end':
                endAdded = True
            elif curDialogueItem.charName.lower() == 'start':
                startAdded = True

    file.close()
    if not endAdded:
        warnings.append('!! Warning !! End node not found')
    if not startAdded:
        warnings.append('!! Warning !! Start node not found')
    return dialogueItems


def testDialogueTree(dialogueItems, warnings):
    dialogueTree = DialogueTree()

    print('\n=============================== Testing Dialogue Tree ===============================\n')
    for item in dialogueItems:
        if 'start' in item.charName.lower():
            item.text = ''
            dialogueTree.root = item
        elif 'end' in item.charName.lower():
            item.text = ''
            dialogueTree.end = item
        for linkNameAndID in item.links:
            for potentialLink in dialogueItems:
                if linkNameAndID[0] == potentialLink.charName and linkNameAndID[1] == potentialLink.nodeID:
                    item.edges.append(potentialLink)

    allPathsLeadToEnd = allPathsLeadToEndDFS(dialogueTree.root, dialogueTree.end, [], warnings)
    if not allPathsLeadToEnd:
        warnings.append('!! Warning !! Not all dialogue paths lead to the end!')
    else:
        print('All paths lead to the end!')


def allPathsLeadToEndDFS(node, endNode, nodeStack, warnings):
    if node == endNode:
        return True
    if len(node.edges) == 0:
        warnings.append(f'!! Warning !! dialogue tree dangling leaf detected:\n{node}')
        return False

    nodeStack.append(node)
    allPathsLeadToEnd = True
    for edge in node.edges:
        if edge in nodeStack:
            warnings.append(f'!! Warning !! dialogue tree loop detected\nfrom:\n{node}\nto:\n{edge}')
        elif not edge.allEdgesSearched:
            edgeLeadsToEnd = allPathsLeadToEndDFS(edge, endNode, nodeStack, warnings)
            if not edgeLeadsToEnd:
                allPathsLeadToEnd = False

    node.allEdgesSearched = True
    nodeStack.remove(node)
    if allPathsLeadToEnd:
        return True
    return False


def writeNewFile(fileName, dialogueItems):
    newFile = open(f'{fileName}.psv', 'w')

    for j in range(len(dialogueItems)):
        item = dialogueItems[j]
        newFile.write(f'{item.charName}|{item.nodeID}|')
        for i in range(len(item.links)):
            link = item.links[i]
            if i < len(item.links) - 1:
                newFile.write(f'{link[0]}-{link[1]},')
            else:
                newFile.write(f'{link[0]}-{link[1]}|')
        if j < len(dialogueItems) - 1:
            newFile.write(f'{item.text}\n')
        else:
            newFile.write(f'{item.text}')
    newFile.close()

def parseTestAndCreateNewFile(fileName):
    warnings = []
    dialogueItems = parseFile(fileName, warnings)
    print('\n============================== Parse Warnings ==============================\n')
    for warning in warnings:
        print(warning)
    warnings.clear()
    testDialogueTree(dialogueItems, warnings)
    print('\n============================== Tree Test Warnings ==============================\n')
    for warning in warnings:
        print(warning)
    print('\n============================== Writing New File ==============================\n')
    writeNewFile(fileName, dialogueItems)
    print('New file written!')


def main():
    if len(sys.argv) > 1:
        os.chdir('../yarns/')
        for fileName in sys.argv[1:]:
            parseTestAndCreateNewFile(fileName)


if __name__ == '__main__':
    main()
