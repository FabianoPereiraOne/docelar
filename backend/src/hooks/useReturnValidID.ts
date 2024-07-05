export const useReturnValidID = (list: any[]) => {
  const listValid = list
    .filter(item => item != null)
    .map(item => {
      return { id: item.id }
    })

  return listValid
}
