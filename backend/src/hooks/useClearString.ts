const useClearString = () => {
  const clearString = (fileName = "") => {
    let cleanedName = fileName.trim()

    cleanedName = cleanedName
      .replace(/[\s]+/g, "-")
      .replace(/[^\w.-]+/g, "")
      .toLowerCase()

    return cleanedName
  }

  return { clearString }
}

export default useClearString
