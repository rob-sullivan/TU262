def are_anagrams(word1, word2):
    word1_sorted = sorted(word1)
    word2_sorted = sorted(word2)
    
    if word1_sorted == word2_sorted:
        return True
    else:
        return False
two_words = input("Enter two words seperated by a space:")
word1,word2 = two_words.split()
if are_anagrams(word1, word2):
    print("these words are angrams")
else:
    print("these words are not angrams")